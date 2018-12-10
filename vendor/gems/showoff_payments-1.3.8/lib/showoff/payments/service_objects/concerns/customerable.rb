module Showoff
  module Payments
    module Services
      module Concerns
        module Customerable
          extend Showoff::Payments::Services::Concerns::BaseConcern

          def sources
            ensure_customer

            sources = client.sources(customer_identity)
            saved_sources_from_client_sources(sources)

          rescue StandardError => e
            handle_error(e)
          end

          def add_source(source_token)
            ensure_customer

            sources = client.add_source(customer_identity, source_token)
            saved_sources_from_client_sources(sources)

          rescue StandardError => e
            handle_error(e)
          end

          def remove_source(source_token)
            ensure_customer

            # NOTE:
            # find by provider identifier here allows for backward compatability with existing versions. Existing versions pass
            # up the provider identifier as the id. New versions going forward will pass up the database identifier
            existing = ::Showoff::Payments::Source.find_by(id: source_token) || ::Showoff::Payments::Source.find_by(provider_identifier: source_token)
            if existing
              provider_identifier = existing.provider_identifier
            else
              provider_identifier = source_token
            end

            #remove source which will return other sources
            sources = client.remove_source(customer_identity, provider_identifier)
            if existing
              existing.update_attributes(active: false)
            end

            saved_sources_from_client_sources(sources)

          rescue StandardError => e
            handle_error(e)
          end

          def make_source_default(source_token)
            ensure_customer

            # NOTE:
            # find by provider identifier here allows for backward compatability with existing versions. Existing versions pass
            # up the provider identifier as the id. New versions going forward will pass up the database identifier
            existing = ::Showoff::Payments::Source.find_by(id: source_token) || ::Showoff::Payments::Source.find_by(provider_identifier: source_token)
            if existing
              provider_identifier = existing.provider_identifier
            else
              provider_identifier = source_token
            end

            sources = client.make_default(customer_identity, provider_identifier)
            if existing
              Showoff::Payments::Source.where(default: true).update_all(default: false)
              existing.update_attributes(default: true, active: true)
            end

            saved_sources_from_client_sources(sources)

          rescue StandardError => e
            handle_error(e)
          end

          # Deprecated
          def make_default(source_token)
            make_source_default(source_token)
          end
          deprecate :make_default, :make_source_default, 2017, 6



        end
      end
    end
  end
end
