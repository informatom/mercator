Contracting.Router.map ->

  @resource "contracts",
    path: "/", ->
      @resource "contract",
        path: "/contract/:contract_id", ->
          @resource "contractItem",
            path: "/item/:contractItem_id", ->
              @resource "consumableItem",
                path: "/consumable/:consumableItem_id"
  return