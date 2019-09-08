class FibonaccisController < ApplicationController
  before_action :set_fibonacci, only: [:show, :edit, :update, :destroy]

  # GET /fibonaccis
  # GET /fibonaccis.json
  def index
    @fibonaccis = Fibonacci.all
  end

  # GET /fibonaccis/1
  # GET /fibonaccis/1.json
  def show
  end

  # GET /fibonaccis/new
  def new
    @fibonacci = Fibonacci.new
  end

  # GET /fibonaccis/1/edit
  def edit
  end

  # POST /fibonaccis
  # POST /fibonaccis.json
  def create
    @fibonacci = Fibonacci.new(fibonacci_params)

    respond_to do |format|
      if @fibonacci.save
        format.html { redirect_to @fibonacci, notice: 'Fibonacci was successfully created.' }
        format.json { render :show, status: :created, location: @fibonacci }
      else
        format.html { render :new }
        format.json { render json: @fibonacci.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fibonaccis/1
  # PATCH/PUT /fibonaccis/1.json
  def update
    respond_to do |format|
      if @fibonacci.update(fibonacci_params)
        format.html { redirect_to @fibonacci, notice: 'Fibonacci was successfully updated.' }
        format.json { render :show, status: :ok, location: @fibonacci }
      else
        format.html { render :edit }
        format.json { render json: @fibonacci.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fibonaccis/1
  # DELETE /fibonaccis/1.json
  def destroy
    @fibonacci.destroy
    respond_to do |format|
      format.html { redirect_to fibonaccis_url, notice: 'Fibonacci was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fibonacci
      @fibonacci = Fibonacci.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fibonacci_params
      params.require(:fibonacci).permit(:number)
    end
end
