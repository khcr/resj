class Admin::SubjectsController < Admin::BaseController
	before_action :current_resource, only: [:edit, :update, :destroy]
	after_action only: [:create, :update, :destroy] { |c| c. track_activity @subject }

	def index
		@table = Table.new(self, Subject)
		@table.respond
	end

	def new
		js 'form'
		@subject = current_user.subjects.new
	end

	def create
		js 'form'
		@subject = current_user.subjects.new(subject_params)
		if @subject.save
			flash[:success] = "Sujet créé"
			render 'redirect', locals: { path: '/admin/subjects' }
		else
			render 'form_progress_error', locals: { object: @subject }
		end
	end

	def edit
		js 'form'
	end

	def update
		js 'form'
		if @subject.update_attributes(subject_params)
			flash[:success] = "Sujet édité"
			render 'redirect', locals: { path: '/admin/subjects' }
		else
			render 'form_progress_error', locals: { object: @subject }
		end
	end

	def destroy
		@subject.destroy
		redirect_to admin_subjects_path, success: t('subject.destroy.success')
	end

	private

	def subject_params
		params.require(:subject).permit(:name, :description, { :theme_ids =>[] }, documents_attributes: [:id, :file, :name, :_destroy] )
	end

	def current_resource
		@subject = Subject.find_by_id(params[:id])
	end
end
