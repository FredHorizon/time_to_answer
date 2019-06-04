class AdminsBackofficeController < ApplicationController
    before_action :authenticate_admin! # no singular porque é o nome do model

    layout 'admins_backoffice' # ativa o uso desse layout
end
