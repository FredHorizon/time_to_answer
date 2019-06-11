class AdminsBackoffice::AdminsController < AdminsBackofficeController
  def index
    @admins = Admin.all
  end

  def edit
    # ação para editar informações de admin
  end
end
