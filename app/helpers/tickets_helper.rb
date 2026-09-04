module TicketsHelper
  def ticket_qr_code(ticket)
    qr = RQRCode::QRCode.new(
      "BOOKMYSHOW:TICKET:#{ticket.qr_token}"
    )

    qr.as_svg(
      color: "000000",
      fill: "ffffff",
      module_size: 1,
      shape_rendering: "crispEdges",
      standalone: true,
      use_path: true,
    ).html_safe
  end
end
