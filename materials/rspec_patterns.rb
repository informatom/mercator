spring rspec --tag focus spec/
, focus: true


# CRUD

describe 'GET #show', focus: true do
  get :show, id: @instance
describe 'GET #index', focus: true do
  get :index
describe 'GET #new', focus: true do
  get :new
describe 'POST #create', focus: true do
  post :create, model:
describe 'GET #edit', focus: true do
  get :edit, id: @instance
describe 'PATCH #update', focus: true do
  patch :update, id: @instance, model: {}
describe 'DELETE #destroy', focus: true do
  delete :destroy, id: @instance

it "renders nothing for xhr request" do
   xhr :post, :action, id: @instance, params:

expect(response).to redirect_to
expect(session[:key]).to eql