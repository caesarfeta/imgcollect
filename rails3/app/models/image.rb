require_relative "../../../../sparql_model/lib/sparql_model.rb"
class Image < SparqlModel

  def initialize( _key=nil )
    @endpoint = Rails.configuration.sparql_endpoint
    @prefixes = {
      :exif => "<http://www.kanzaki.com/ns/exif#>",
    }
    @attributes = {
      #-------------------------------------------------------------
      #  Image paths
      #-------------------------------------------------------------
      :path => [ "this:path", ::String, SINGLE, REQUIRED, UNIQUE, KEY ],
      :original => [ "this:original", ::String, SINGLE, REQUIRED ],
      :thumb => [ "this:thumb", ::String, SINGLE, REQUIRED, UNIQUE ],
      :basic => [ "this:basic", ::String, SINGLE, REQUIRED, UNIQUE ],
      :advanced => [ "this:advanced", ::String, SINGLE, REQUIRED, UNIQUE ],
      #-------------------------------------------------------------
      #  Name
      #-------------------------------------------------------------
      :name => [ "this:name", ::String, SINGLE ],
      #-------------------------------------------------------------
      #  Keywords
      #-------------------------------------------------------------
      :keywords => [ "this:keywords", ::String, MULTI ],
      #-------------------------------------------------------------
      #  Exif Metadata
      #-------------------------------------------------------------
      :image_descrption => [ "exif:imageDescription",  ::String, SINGLE ],
      :make => [ "exif:make",  ::String, SINGLE ],
      :model => [ "exif:model", ::String, SINGLE ],
      :orientation => [ "exif:orientation", ::String, SINGLE ],
      :x_resolution => [ "exif:xResolution", ::Integer, SINGLE ],
      :y_resolution => [ "exif:yResolution", ::Integer, SINGLE ],
      :resolution_unit => [ "exif:resolutionUnit", ::String, SINGLE ],
      :software => [ "exif:software", ::String, SINGLE ],
      :date_time => [ "exif:dateTime", ::String, SINGLE ],
      :ycb_cr_positioning => [ "exif:ycbCrPositioning", ::String, SINGLE ],
      :exposure_time => [ "exif:exposureTime", ::String, SINGLE ],
      :f_number => [ "exif:fNumber", ::String, SINGLE ],
      :exposure_program => [ "exif:exposureProgram", ::String, SINGLE ],
      :iso_speed_ratings => [ "exif:isoSpeedRatings", ::String, SINGLE ],
      :date_time_original => [ "exif:dateTimeOriginal", ::String, SINGLE ],
      :date_time_digitized => [ "exif:dateTimeDigitized", ::String, SINGLE ],
      :compressed_bits_per_pixel => [ "exif:compressedBitsPerPixel", ::String, SINGLE ],
      :brightness_value => [ "exif:brightnessValue", ::String, SINGLE ],
      :exposure_bias_value => [ "exif:exposureBiasValue", ::String, SINGLE ],
      :max_aperture_value => [ "exif:maxApertureValue", ::String, SINGLE ],
      :metering_mode => [ "exif:meteringMode", ::String, SINGLE ],
      :light_source => [ "exif:lightSource", ::String, SINGLE ],
      :flash => [ "exif:flash", ::String, SINGLE ],
      :focal_length => [ "exif:focalLength", ::String, SINGLE ],
      :user_comment => [ "exif:userComment", ::String, SINGLE ],
      :color_space => [ "exif:colorSpace", ::String, SINGLE ],
      :pixel_x_dimension => [ "exif:pixelXDimension", ::String, SINGLE ],
      :pixel_y_dimension => [ "exif:pixelYDimension", ::String, SINGLE ],
      :custom_rendered => [ "exif:customRendered", ::String, SINGLE ],
      :exposure_mode => [ "exif:exposureMode", ::String, SINGLE ],
      :white_balance => [ "exif:whiteBalance", ::String, SINGLE ],
      :focal_length_in_35mm_film => [ "exif:focalLengthIn35mmFilm", ::String, SINGLE ],
      :scene_capture_type => [ "exif:sceneCaptureType", ::String, SINGLE ],
      :contrast => [ "exif:contrast", ::String, SINGLE ],
      :saturation => [ "exif:saturation", ::String, SINGLE ],
      :sharpness => [ "exif:sharpness", ::String, SINGLE ],
      :image_unique_id => [ "exif:imageUniqueId", ::String, SINGLE ]
    }
    super( _key )
  end
  
end
