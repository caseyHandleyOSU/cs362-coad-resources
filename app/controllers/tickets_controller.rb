class TicketsController < ApplicationController
  include TicketsHelper

  before_action :authenticate_user!
  before_action :authenticate_admin, only: :destroy
 
  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.phone = format_phone_number(@ticket.phone)
    
    if @ticket.save
      redirect_to ticket_submitted_path
    else
      render :new
    end
  end

  def show
    return redirect_to dashboard_path unless current_user&.organization&.approved? || current_user.admin?
    @ticket = Ticket.find_by(id: params[:id])
    return redirect_to dashboard_path, alert: "Ticket not found." unless @ticket
  end

  def capture
    return redirect_to dashboard_path unless current_user&.organization&.approved?
    @ticket = Ticket.find_by(id: params[:id])
    return redirect_to dashboard_path, alert: "Ticket not found." unless @ticket
    
    if TicketService.capture_ticket(@ticket.id, current_user) == :ok
      redirect_to "#{dashboard_path}#tickets:open"
    else
      render :show
    end
  end

  def release
    return redirect_to dashboard_path unless current_user&.organization&.approved?
    @ticket = Ticket.find_by(id: params[:id])
    return redirect_to dashboard_path, alert: "Ticket not found." unless @ticket
    
    if TicketService.release_ticket(@ticket.id, current_user) == :ok
      if current_user.admin?
        redirect_to "#{dashboard_path}#tickets:captured"
      else
        redirect_to "#{dashboard_path}#tickets:organization"
      end
    else
      render :show
    end
  end

  def close
    return redirect_to dashboard_path unless current_user&.organization&.approved?
    @ticket = Ticket.find_by(id: params[:id])
    return redirect_to dashboard_path, alert: "Ticket not found." unless @ticket

    if TicketService.close_ticket(@ticket.id, current_user) == :ok
      if current_user.admin?
        redirect_to "#{dashboard_path}#tickets:open"
      else
        redirect_to "#{dashboard_path}#tickets:organization"
      end
    else
      render :show
    end
  end

  def destroy
    @ticket = Ticket.find_by(id: params[:id])
    return redirect_to dashboard_path, alert: "Ticket not found." unless @ticket
    
    @ticket.destroy
    redirect_to "#{dashboard_path}#tickets", notice: "Ticket #{@ticket.id} was deleted."
  end

  private

  def ticket_params
    params.require(:ticket).permit(:name, :phone, :description, :region_id, :resource_category_id)
  end

end
