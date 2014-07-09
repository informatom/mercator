Contracting.Router.map ->
  @resource "contracts",
    path: "/", ->
      @resource "contract",
        path: "/contract/:contract_id", ->
          @resource "contractitem",
            path: "/item/:contractitem_id", ->
              @resource "consumableitem",
                path: "/consumable/:consumableitem_id"
  return