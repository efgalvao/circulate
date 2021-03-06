module LoansHelper
  def undo_button(loan)
    name, method, path, params = if loan.ended?
      ["return", :patch, admin_loan_path(loan), {loan: {ended_at: nil}}]
    elsif loan.renewal?
      ["renewal", :delete, admin_renewal_path(loan)]
    else
      ["loan", :delete, admin_loan_path(loan)]
    end
    button_to path, method: method, class: "btn btn-sm", remote: true, params: params do
      feather_icon("x") + "Undo #{name}"
    end
  end

  def humanize_due_date(loan)
    if loan.due_at.to_date == Date.today
      "today"
    elsif loan.due_at.to_date == Date.tomorrow
      "tomorrow"
    else
      loan.due_at.strftime("%a %m/%d")
    end
  end

  def render_loan_status(loan)
    appointment = loan.upcoming_appointment 
    appointment_time = 
      if appointment
        ". Scheduled for return at #{format_date(appointment.starts_at)} " +
        format_time_range(appointment.starts_at, appointment.ends_at)
      else 
        ""
      end
    loan.status.capitalize + appointment_time
  end

  private

  def format_date(date)
    date.strftime("%a, %-m/%-d")
  end

  def format_time_range(starts_at, ends_at)
    "#{starts_at.strftime('%l%P')} - #{ends_at.strftime('%l%P')}"
  end
end
