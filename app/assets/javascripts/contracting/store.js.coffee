# http://emberjs.com/guides/models/#toc_store
# http://emberjs.com/guides/models/pushing-records-into-the-store/

Contracting.ApplicationStore = DS.Store

# Override the default adapter with the `DS.ActiveModelAdapter` which
# is built to work nicely with the ActiveModel::Serializers gem.

Contracting.ApplicationAdapter = DS.ActiveModelAdapter.extend
  namespace: 'contracting'