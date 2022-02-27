class ErrorsController < ActionController::Base
  #-----------------------------------------------------------------------------
  # GET not_found /errors/404
  #-----------------------------------------------------------------------------
  def not_found
    if request.env["REQUEST_PATH"] =~ /^\/api/
      render json: { error: "not-found" }.to_json, status: 404
    else
      render text: "404 Not found", status: 404
    end
  end

  #-----------------------------------------------------------------------------
  # GET exception /errors/500
  #-----------------------------------------------------------------------------
  def exception
    if request.env["REQUEST_PATH"] =~ /^\/api/
      render json: { error: "internal-server-error" }.to_json, status: 500
    else
      render text: "500 Internal Server Error", status: 500
    end
  end
end