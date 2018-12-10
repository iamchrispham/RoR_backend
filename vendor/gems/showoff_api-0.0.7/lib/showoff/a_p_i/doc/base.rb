module Showoff
  module API
    module Doc
      module Base
        include Apipie::DSL::Concern

        attr_reader :action_id, :controller_id

        def set_version(version)
          @version = version.nil? ? 1 : version
        end
        attr_reader :version

        def set_api_endpoint_base(api_endpoint_base)
          @api_endpoint_base = api_endpoint_base
        end
        attr_reader :api_endpoint_base

        def set_action_name(action_name)
          @action_name = action_name
        end

        def resource(resource)
          name.downcase =~ /.*::(oauth|v\d+)::.*/

          set_version Regexp.last_match(1)

          resource_path_root = @version.eql?('oauth') ? '' : 'api/'
          resource_path = @version.eql?('oauth') ? '' : "#{resource}/"

          set_api_endpoint_base "#{resource_path_root}#{@version}/#{resource_path}"

          controller_name = resource.to_s.camelize + 'Controller'

          @controller_id = resource.to_s.underscore
        end

        def doc_for(action_name, &block)
          set_action_name(action_name)

          if @defaults && (@defaults_exceptions.nil? || !@defaults_exceptions.include?(action_name))
            instance_eval(&@defaults)
          end

          instance_eval(&block)

          api_version @version if @version

          # define method for docs to bind to
          define_method(generate_method_name_for(action_name)) do
          end
        end

        def auth_with_bearer
          include Showoff::API::Doc::BearerAuthentication
        end

        def defaults(except: nil, &block)
          @defaults_exceptions = except
          @defaults_exceptions = [except] if @defaults_exceptions.is_a?(Symbol)
          @defaults = block
        end

        def response_example
          example = example_json.nil? ? { example: :undefined } : example_json.last['response_data']
          pretty_json(example)
        end

        private

        def generate_method_name_for(action_name)
          ('api_generated_doc_method_' + action_name.to_s + '_v' + version.to_s + '_doc').to_sym
        end

        def pretty_json(hash)
          JSON.pretty_generate(JSON.parse(hash.to_json))
        end

        def example_json
          json_path = File.join(Rails.root, 'doc', 'apipie_examples.json')
          return nil unless File.exist?(json_path)

          json_file = File.read(json_path)

          if Apipie.configuration.namespaced_resources
            apipie_namespaced_controller_name = name.split('::').map(&:underscore).join
            apipie_namespaced_controller_name =~ /(api.+)_doc/

            @controller_id = Regexp.last_match(1)
            return nil unless @controller_id
          end

          JSON.parse(json_file)["#{@controller_id}##{@action_name}"]
        rescue
          nil
        end
      end
    end
  end
end
