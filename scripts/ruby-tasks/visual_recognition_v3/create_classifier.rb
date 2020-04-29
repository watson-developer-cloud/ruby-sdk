
    ##
    # @!method create_classifier(name:, **args)
    # Create a classifier.
    # Train a new multi-faceted classifier on the uploaded image data. Create your
    #   custom classifier with positive or negative examples. Include at least two sets of
    #   examples, either two positive example files or one positive and one negative file.
    #   You can upload a maximum of 256 MB per call.
    #
    #   Encode all names in UTF-8 if they contain non-ASCII characters (.zip and image
    #   file names, and classifier and class names). The service assumes UTF-8 encoding if
    #   it encounters non-ASCII characters.
    # @param name [String] The name of the new classifier. Encode special characters in UTF-8.
    # @param args [Hash] Hash for optional parameters
    # @option args classname_positive_examples [File] A .zip file of images that depict the visual subject of a class in the new
    #   classifier. You can include more than one positive example file in a call.
    #
    #   Specify the parameter name by appending `_positive_examples` to the class name.
    #   For example, `goldenretriever_positive_examples` creates the class
    #   **goldenretriever**.
    #
    #   Include at least 10 images in .jpg or .png format. The minimum recommended image
    #   resolution is 32X32 pixels. The maximum number of images is 10,000 images or 100
    #   MB per .zip file.
    #
    #   Encode special characters in the file name in UTF-8.
    # @param negative_examples [File] A .zip file of images that do not depict the visual subject of any of the classes
    #   of the new classifier. Must contain a minimum of 10 images.
    #
    #   Encode special characters in the file name in UTF-8.
    # @option args classname_positive_examples_filename [String] The filename for classname_positive_examples.
    # @option args negative_examples_filename [String] The filename for negative_examples.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def create_classifier(name:, **args)
      raise ArgumentError("name must be provided") if name.nil?

      raise ArgumentError("<classname>_positive_examples must be provided") unless args.keys.any? { |key| key.to_s.end_with?("_positive_examples") }

      positive_keys = args.keys
      positive_keys.keep_if { |key| key.to_s.end_with?("_positive_examples") }
      headers = {
      }
      params = {
        "version" => @version
      }
      mime_type = "application/octet-stream"
      positive_keys.each do |k|
        unless args[k].instance_of?(StringIO) || args[k].instance_of?(File)
          args[k] = args[k].respond_to?(:to_json) ? StringIO.new(args[k].to_json) : StringIO.new(args[k])
        end
        if !args[(k.to_s + "_filename").to_sym].nil?
          args[k] = args[k].instance_of?(StringIO) ? HTTP::FormData::File.new(args[k], content_type: mime_type, filename: args[(k.to_s + "_filename").to_sym]) : HTTP::FormData::File.new(args[k].path, content_type: mime_type, filename: args[(k.to_s + "_filename").to_sym])
        else
          args[k] = args[k].instance_of?(StringIO) ? HTTP::FormData::File.new(args[k], content_type: mime_type) : HTTP::FormData::File.new(args[k].path, content_type: mime_type)
        end
      end
      unless args[:negative_examples].nil?
        mime_type = "application/octet-stream"
        unless args[:negative_examples].instance_of?(StringIO) || args[:negative_examples].instance_of?(File)
          args[:negative_examples] = args[:negative_examples].respond_to?(:to_json) ? StringIO.new(args[:negative_examples].to_json) : StringIO.new(args[:negative_examples])
        end
        if args[:negative_examples_filename]
          args[:negative_examples] = args[:negative_examples].instance_of?(StringIO) ? HTTP::FormData::File.new(args[:negative_examples], content_type: mime_type, filename: args[:negative_examples_filename]) : HTTP::FormData::File.new(args[:negative_examples].path, content_type: mime_type, filename: args[:negative_examples_filename])
        else
          args[:negative_examples] = args[:negative_examples].instance_of?(StringIO) ? HTTP::FormData::File.new(args[:negative_examples], content_type: mime_type) : HTTP::FormData::File.new(args[:negative_examples].path, content_type: mime_type)
        end
      end
      form_hash = { name: name }
      positive_keys.each { |k| form_hash[k] = args[k] }
      form_hash[:negative_examples] = args[:negative_examples] unless args[:negative_examples].nil?
      method_url = "/v3/classifiers"
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: form_hash,
        accept_json: true
      )
      response
    end
