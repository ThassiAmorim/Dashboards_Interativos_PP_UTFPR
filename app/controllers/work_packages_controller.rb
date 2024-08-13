class WorkPackagesController < ApplicationController
  before_action :set_work_package, only: %i[show]

  def index
    @work_packages = WorkPackage.where(parent_id: nil).includes(:children).order(:id)
  end

  def show
    @work_packages_filhos = WorkPackage.where(parent_id: params[:id])
  end

  def dashboard
    @activities = WorkPackage.where(type_id: 8).includes(:category)

    # Calculando a contagem de atividades por categoria (nome)
    @activities_by_category_name = @activities.joins(:category).group('categories.name').count

    # Calculando a média de progresso por categoria (nome)
    @progress_by_category_name = @activities.joins(:category).group('categories.name').average(:done_ratio)

    # Convertendo os dados para um formato adequado para o JavaScript
    @activities_data = @activities.includes(:category).group_by { |activity| activity.category.name }
                                  .transform_values { |activities| activities.map { |activity| { name: activity.subject, completion: activity.done_ratio } } }
                                  .to_json
    Rails.logger.debug "Activities data: #{@activities_data.inspect}"
  end


  def relatorio
    @work_packages_graduacao = WorkPackage.where("subject LIKE ? AND parent_id IS NULL", "GR.%").count
    @work_packages_pos = WorkPackage.where("subject LIKE ? AND parent_id IS NULL", "PG.%").count
    @work_packages_relacoes = WorkPackage.where("subject LIKE ? AND parent_id IS NULL", "REC.%").count
    @work_packages_infra = WorkPackage.where("subject LIKE ? AND parent_id IS NULL", "INFRA.%").count
    @work_packages_gestao = WorkPackage.where("subject LIKE ? AND parent_id IS NULL", "GT.%").count
    @work_packages_processos = WorkPackage.where("subject LIKE ? AND parent_id IS NULL", "GTP.%").count
    @work_packages_servidores = WorkPackage.where("subject LIKE ? AND parent_id IS NULL", "SV.%").count
    @work_packages_discentes= WorkPackage.where("subject LIKE ? AND parent_id IS NULL", "DI.%").count
    @work_packages_comunidade= WorkPackage.where("subject LIKE ? AND parent_id IS NULL", "CA.%").count
    @work_packages_total = WorkPackage.where(parent_id:nil).count

  end

  def search
    @query = params[:query]
    @filter = params[:filter]

    # Lógica para buscar atividades com base nos parâmetros
    @work_packages = WorkPackage.where(type_id:8)

    if @query.present?
      @work_packages = @work_packages.where("subject ILIKE ?", "%#{@query}%")
    end

    if @filter.present?
      case @filter
      when "Graduação"
        @work_packages = @work_packages.where("subject LIKE ?", "GR.%")
      when "Pesquisa e Pós-Graduação"
        @work_packages = @work_packages.where("subject LIKE ?", "PG.%")
      when "Relações Empresariais e Comunitárias"
        @work_packages = @work_packages.where("subject LIKE ?", "REC.%")
      when "Implementações e Infraestrutura"
        @work_packages = @work_packages.where("subject LIKE ?", "INFRA.%")
      when "Gestão do Campus"
        @work_packages = @work_packages.where("subject LIKE ?", "GT.%")
      when "Processos"
        @work_packages = @work_packages.where("subject LIKE ?", "GTP.%")
      when "Servidores"
        @work_packages = @work_packages.where("subject LIKE ?", "SV.%")
      when "Discentes"
        @work_packages = @work_packages.where("subject LIKE ?", "DI.%")
      when "Comunidade Acadêmica"
        @work_packages = @work_packages.where("subject LIKE ?", "CA.%")
      else
        @work_packages = @work_packages
      end
    end
    @work_packages = @work_packages.order(:id)
  end

  private

  def set_work_package
    @work_package = WorkPackage.find(params[:id])
  end


end
