class TasksController < ApplicationController
  def index
    @tasks = Task.all

    # Filter by search term if provided
    if params[:search].present?
      @tasks = @tasks.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%")
    end
    # Filter by tag if tag_id is provided
    if params[:tag_id].present?
      @tasks = @tasks.joins(:tags).where(tags: { id: params[:tag_id] })
    end
  end

  def show
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      redirect_to tasks_path, alert: "Task not found."
    end
  end

  def new
    #    @count = Task.count
    #   @task = Task.new(position: @count + 1)
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    Rails.logger.debug "Task params: #{task_params.inspect}"
    if @task.save
      # Assign users to the task
      if params[:task][:user_ids].present?
        params[:task][:user_ids].each do |user_id|
          TaskAssignment.create(task: @task, user_id: user_id) if user_id.present?
        end
      end
      redirect_to @task, notice: "Task was successfully created."
    else
      Rails.logger.debug "Task errors: #{@task.errors.full_messages}"
      @users = User.all # Load users again to show in the form
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
    @users = User.all # Assuming you have a User model and want to show all users
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      # Update user assignments
      @task.task_assignments.destroy_all # Clear existing assignments
      if params[:task][:user_ids].present?
        params[:task][:user_ids].each do |user_id|
          TaskAssignment.create(task: @task, user_id: user_id) if user_id.present?
        end
      end
      redirect_to @task, notice: "Task was successfully updated."
    else
      @users = User.all # Load users again to show in the form
      render :edit
    end
  end

  def delete
    @task = Task.find(params[:id])
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: "Task was successfully deleted." # Added notice for user feedback
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :completed, :category_id, tag_ids: [], user_ids: [])
  end
end
