# frozen_string_literal: true

class InstructionsController < ApplicationController

  def index

  	instructions = Instruction.where("id in (select id from instructions)")
  	render json: InstructionsPresenter.present(instructions)

  end

  def destroy
    instruction = Instruction.find params[:id]
    instruction.delete

    render status: :ok
  end

  def create

  	instruction = params[:instruction]
    persisted_instruction = Instruction.create(service_id: instruction[:service_id], instruction: instruction[:instruction] )
  	render status: :created, json: InstructionsPresenter.present(persisted_instruction)
  end

  def update

    instruction = Instruction.find(params[:id])
    instruction.instruction = params[:instruction][:instruction]
    instruction.save

    render status: :ok, json: InstructionsPresenter.present(instruction)

  end

end