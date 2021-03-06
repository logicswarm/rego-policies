package lib.konstraint.core

default is_gatekeeper = false

is_gatekeeper {
    has_field(input, "review")
    has_field(input.review, "object")
}

resource = input.review.object {
    is_gatekeeper
}

resource = input {
    not is_gatekeeper
}

format(msg) = {"msg": msg} {
    true
}

format_with_id(msg, id) = msg_fmt {
    msg_fmt := {
        "msg": sprintf("%s: %s", [id, msg]),
        "details": {"policyID": id}
    }
}

apiVersion = resource.apiVersion
name = resource.metadata.name
kind = resource.kind
labels = resource.metadata.labels
annotations = resource.metadata.annotations
gv := split(apiVersion, "/")
group = gv[0] {
    contains(apiVersion, "/")
}
group = "core" {
    not contains(apiVersion, "/")
}
version := gv[count(gv) - 1]

#parameters = input.parameters {
#    is_gatekeeper
#}

#parameters = data.parameters {
#   not is_gatekeeper
#}

has_field(obj, field) {
    not object.get(obj, field, "N_DEFINED") == "N_DEFINED"
}

missing_field(obj, field) = true {
    obj[field] == ""
}

missing_field(obj, field) = true {
    not has_field(obj, field)
}
