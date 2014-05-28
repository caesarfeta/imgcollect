class UploadController < ActionController::Base
  def index
    render :file => 'app/views/upload/form.haml'
  end
  def file
    post = FileUpload.save( params )
    render :text => "File has been uploaded successfully"
  end
end
