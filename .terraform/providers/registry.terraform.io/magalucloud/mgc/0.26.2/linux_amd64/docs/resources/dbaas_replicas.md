---
# generated by https://github.com/hashicorp/terraform-plugin-docs
page_title: "mgc_dbaas_replicas Resource - terraform-provider-mgc"
subcategory: "Database"
description: |-
  Database replicas management.
---

# mgc_dbaas_replicas (Resource)

Database replicas management.

## Example Usage

```terraform
resource "mgc_dbaas_replicas" "dbaas_replica" {
  name = "dbaas-replica"
  source_id = "123"
}
```

<!-- schema generated by tfplugindocs -->
## Schema

### Required

- `name` (String)
- `source_id` (String)

### Optional

- `flavor_id` (String)

### Read-Only

- `addresses` (Attributes List) (see [below for nested schema](#nestedatt--addresses))
- `created_at` (String)
- `datastore_id` (String) Datastore unique identifier (Deprecated).
**Deprecated**: This property is being deprecated in favor of `engine_id`. Please update your requests to use `engine_id` for improved functionality and future compatibility.
- `engine_id` (String) Engine unique identifier.
- `finished_at` (String)
- `generation` (String) Current database instance generation
- `id` (String) Database Replica Unique Id
- `parameters` (Attributes List) (see [below for nested schema](#nestedatt--parameters))
- `started_at` (String)
- `status` (String)
- `updated_at` (String)
- `volume` (Attributes) (see [below for nested schema](#nestedatt--volume))

<a id="nestedatt--addresses"></a>
### Nested Schema for `addresses`

Read-Only:

- `access` (String)
- `address` (String)
- `type` (String)


<a id="nestedatt--parameters"></a>
### Nested Schema for `parameters`

Read-Only:

- `name` (String) Database parameter name.
- `value` (Attributes) Database parameter value. (see [below for nested schema](#nestedatt--parameters--value))

<a id="nestedatt--parameters--value"></a>
### Nested Schema for `parameters.value`

Read-Only:

- `boolean1` (Boolean)
- `integer1` (Number)
- `number1` (Number)
- `string1` (String)



<a id="nestedatt--volume"></a>
### Nested Schema for `volume`

Read-Only:

- `size` (Number) The size of the volume (in GiB).
- `type` (String) The type of the volume.
