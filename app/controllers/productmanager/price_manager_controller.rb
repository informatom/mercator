class Productmanager::PriceManagerController < Productmanager::ProductmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js, :text

  def index
    product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.text {
        render json: {
          status: "success",
          total: 13,
          records: [{
            recid: 1,
            attribute: I18n.t("attributes.number") + " DE",
            value: product.number
          }, {
            recid: 2,
            attribute: I18n.t("attributes.title") + " DE",
            value: product.title_de
          }, {
            recid: 3,
            attribute: I18n.t("attributes.title") + " EN",
            value: product.title_en
          }, {
            recid: 4,
            attribute: I18n.t("attributes.description") + " DE",
            value: product.description_en
          }, {
            recid: 5,
            attribute: I18n.t("attributes.description") + " EN",
            value: product.description_en
          }, {
            recid: 6,
            attribute: I18n.t("attributes.long_description") + " DE",
            value: ActionController::Base.helpers.strip_tags(product.long_description_de)
          }, {
            recid: 7,
            attribute: I18n.t("attributes.long_description") + " EN",
            value: ActionController::Base.helpers.strip_tags(product.long_description_en)
          }, {
            recid: 8,
            attribute: I18n.t("attributes.warranty") + " DE",
            value: product.warranty_de
          }, {
            recid: 9,
            attribute: I18n.t("attributes.warranty") + " EN",
            value: product.warranty_en
          }, {
            recid: 10,
            attribute: I18n.t("attributes.novelty"),
            value: product.novelty.to_s
          }, {
            recid: 11,
            attribute: I18n.t("attributes.topseller"),
            value: product.topseller
          }, {
            recid: 12,
            attribute: I18n.t("attributes.created_at"),
            value: I18n.l(product.created_at)
          }, {
            recid: 13,
            attribute: I18n.t("attributes.updated_at"),
            value: I18n.l(product.updated_at)
          }]
        }
      }
    end
  end
end