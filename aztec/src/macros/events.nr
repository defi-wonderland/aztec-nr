use crate::{
    macros::utils::{compute_struct_selector, derive_serialize_if_not_implemented, get_trait_impl_method},
    utils::cmap::CHashMap,
};
use std::{meta::ctstring::AsCtString, panic};

/// A map from event selector to event signature indicating whether the event selector has already been seen during the
/// contract compilation - prevents event selector collisions.
pub comptime mut global EVENT_SELECTORS: CHashMap<Field, CtString> = CHashMap::new();

comptime fn generate_event_interface_and_get_selector(s: TypeDefinition) -> (Quoted, Field) {
    let name = s.name();

    let event_selector = compute_struct_selector(s, quote { crate::event::EventSelector::from_signature });

    let from_field = get_trait_impl_method(
        quote { crate::event::EventSelector }.as_type(),
        quote { crate::protocol::traits::FromField },
        quote { from_field },
    );

    (
        quote {
        impl aztec::event::event_interface::EventInterface for $name {
            fn get_event_type_id() -> aztec::event::EventSelector {
                $from_field($event_selector)
            }
        }
    },
        event_selector,
    )
}

comptime fn event_signature_of_type(typ: Type) -> CtString {
    if typ.is_field() {
        "Field".as_ctstring()
    } else if typ.as_integer().is_some() {
        let (is_signed, bit_size) = typ.as_integer().unwrap();
        if is_signed {
            f"i{bit_size}".as_ctstring()
        } else {
            f"u{bit_size}".as_ctstring()
        }
    } else if typ.is_bool() {
        "bool".as_ctstring()
    } else if typ.as_str().is_some() {
        let str_len_typ = typ.as_str().unwrap();
        let str_len = str_len_typ.as_constant().unwrap();
        f"str<{str_len}>".as_ctstring()
    } else if typ.as_array().is_some() {
        let (element_type, array_len) = typ.as_array().unwrap();
        let array_len = if array_len.as_constant().is_some() {
            let const_len = array_len.as_constant().unwrap();
            f"{const_len}".as_ctstring()
        } else {
            f"{array_len}".as_ctstring()
        };
        let element_typ_quote = event_signature_of_type(element_type);
        f"[{element_typ_quote};{array_len}]".as_ctstring()
    } else if typ.as_data_type().is_some() {
        let (s, generics) = typ.as_data_type().unwrap();
        let field_signatures = s
            .fields(generics)
            .map(|(_, typ, _)| event_signature_of_type(typ))
            .join(",".as_ctstring());
        f"({field_signatures})".as_ctstring()
    } else if typ.as_tuple().is_some() {
        let types = typ.as_tuple().unwrap();
        let field_signatures = types.map(|typ: Type| event_signature_of_type(typ)).join(",".as_ctstring());
        f"({field_signatures})".as_ctstring()
    } else {
        panic(f"Unsupported type {typ}")
    }
}

comptime fn compute_event_signature(s: TypeDefinition) -> CtString {
    let struct_name = s.name();
    let args_signatures = s
        .fields_as_written()
        .map(|(_, typ, _)| event_signature_of_type(typ))
        .join(",".as_ctstring());
    f"{struct_name}({args_signatures})".as_ctstring()
}

comptime fn register_event_selector(event_selector: Field, event_signature: CtString) {
    let existing_event = EVENT_SELECTORS.get(event_selector);
    if existing_event.is_some() {
        let existing_event = existing_event.unwrap();
        // Allow exact re-registration of the same event signature, but reject selector collisions even when two
        // declarations have the same event name but different fields.
        if existing_event != event_signature {
            panic(
                f"Event selector collision detected between events '{event_signature}' and '{existing_event}'",
            );
        }
    } else {
        EVENT_SELECTORS.insert(event_selector, event_signature);
    }
}

/// Generates the core event functionality for a struct, including the
/// [`EventInterface`](crate::event::event_interface::EventInterface) implementation (which provides the event type
/// id) and a [`Serialize`](crate::protocol::traits::Serialize) implementation if one is not already provided.
///
/// ## Requirements
///
/// Events can be emitted both privately and publicly. Public emission imposes no requirements, but for an event to be
/// emittable privately its serialization length must not exceeed
/// [`MAX_EVENT_SERIALIZED_LEN`](crate::messages::logs::event::MAX_EVENT_SERIALIZED_LEN).
pub comptime fn event(s: TypeDefinition) -> Quoted {
    let (event_interface_impl, event_selector) = generate_event_interface_and_get_selector(s);
    register_event_selector(event_selector, compute_event_signature(s));

    let serialize_impl = derive_serialize_if_not_implemented(s);

    s.add_abi("events");

    quote {
        $event_interface_impl
        $serialize_impl
    }
}
