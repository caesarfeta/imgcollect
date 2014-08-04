require_relative "../../../../sparql_model/lib/sparql_model.rb"
class Image < SparqlModel

  def initialize( _key=nil )
    @endpoint = Rails.configuration.sparql_endpoint
    @prefixes = {
      :exif => "<http://www.kanzaki.com/ns/exif#>",
      :cite =>  "<http://www.homermultitext.org/cite/rdf/>"
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
      :brightness_value => [ "exif:brightnessValue", ::String, SINGLE ],
      :color_space => [ "exif:colorSpace", ::String, SINGLE ],
      :compressed_bits_per_pixel => [ "exif:compressedBitsPerPixel", ::String, SINGLE ],
      :contrast => [ "exif:contrast", ::String, SINGLE ],
      :custom_rendered => [ "exif:customRendered", ::String, SINGLE ],
      :date_time => [ "exif:dateTime", ::Fixnum, SINGLE ],
      :exposure_bias_value => [ "exif:exposureBiasValue", ::String, SINGLE ],
      :exposure_mode => [ "exif:exposureMode", ::String, SINGLE ],
      :exposure_program => [ "exif:exposureProgram", ::Fixnum, SINGLE ],
      :exposure_time => [ "exif:exposureTime", ::Rational, SINGLE ],
      :flash => [ "exif:flash", ::String, SINGLE ],
      :focal_length => [ "exif:focalLength", ::String, SINGLE ],
      :focal_length_in_35mm_film => [ "exif:focalLengthIn35mmFilm", ::String, SINGLE ],
      :f_number => [ "exif:fNumber", ::Rational, SINGLE ],
      :height => [ "this:height", ::Fixnum, SINGLE ],
      :image_description => [ "exif:imageDescription",  ::String, SINGLE ],
      :image_unique_id => [ "exif:imageUniqueId", ::String, SINGLE ],
      :iso_speed_ratings => [ "exif:isoSpeedRatings", ::Fixnum, SINGLE ],
      :latitude => [ "exif:latitude", ::Fixnum, SINGLE ],
      :light_source => [ "exif:lightSource", ::String, SINGLE ],
      :longitude => [ "exif:longitude", ::Fixnum, SINGLE ],
      :make => [ "exif:make",  ::String, SINGLE ],
      :max_aperture_value => [ "exif:maxApertureValue", ::String, SINGLE ],
      :metering_mode => [ "exif:meteringMode", ::String, SINGLE ],
      :model => [ "exif:model", ::String, SINGLE ],
      :orientation => [ "exif:orientation", ::String, SINGLE ],
      :pixel_x_dimension => [ "exif:pixelXDimension", ::String, SINGLE ],
      :pixel_y_dimension => [ "exif:pixelYDimension", ::String, SINGLE ],
      :resolution_unit => [ "exif:resolutionUnit", ::Fixnum, SINGLE ],
      :saturation => [ "exif:saturation", ::String, SINGLE ],
      :scene_capture_type => [ "exif:sceneCaptureType", ::String, SINGLE ],
      :sharpness => [ "exif:sharpness", ::String, SINGLE ],
      :software => [ "exif:software", ::String, SINGLE ],
      :user_comment => [ "exif:userComment", ::String, SINGLE ],
      :white_balance => [ "exif:whiteBalance", ::String, SINGLE ],
      :width => [ "this:width", ::Fixnum, SINGLE ],
      :x_resolution => [ "exif:xResolution", ::Rational, SINGLE ],
      :ycb_cr_positioning => [ "exif:ycbCrPositioning", ::String, SINGLE ],
      :y_resolution => [ "exif:yResolution", ::Rational, SINGLE ],
      #-------------------------------------------------------------
      #  CITE collection stuff
      #-------------------------------------------------------------
      :license => [ "cite:license", ::String, SINGLE ]
    }
    super( _key )
  end
end
