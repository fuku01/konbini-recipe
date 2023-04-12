class TodosController < ApplicationController
  # GET /todos
  def index
    todos = Todo.all
    render json: todos
  end

  # GET /todos/1
  def show
    todo = Todo.find(params[:id])
    render json: todo
  end

  # POST /todos
  def create
    todo = Todo.new(title: params[:title], content: params[:content], completed: params[:completed])

    if todo.save
      render json: todo, status: :created
    else
      render json: todo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/1
  def update
    todo = Todo.find(params[:id])

    if todo.update(completed: params[:completed])
      render json: todo
    else
      render json: todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1
  def destroy
    todo = Todo.find(params[:id])
    if todo.destroy
      render json: { message: "削除に成功しました." }
    else
      render json: { message: "削除に失敗しました." }, status: :unprocessable_entity
    end
  end
end
