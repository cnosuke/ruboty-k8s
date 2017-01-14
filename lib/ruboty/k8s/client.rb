require 'base64'
require 'kubeclient'

class Ruboty::K8s::Client
  attr_reader :v1, :v1beta1

  def initialize(config)
    @config = config
    @v1 = setup_versions('api/', 'v1')
    @v1beta1 = setup_versions('apis/extensions/', 'v1beta1')
  end

  def setup_versions(api_prefix, api_version)
    ::Kubeclient::Client.new(
      "#{@config['api_endpoint']}#{api_prefix}",
      api_version,
      auth_options: auth_options,
      ssl_options: ssl_options
    )
  end

  private

  def auth_options
    { bearer_token: Base64.decode64(@config['bearer_token_base64']) }
  end

  def ssl_options
    cert_store = OpenSSL::X509::Store.new
    cert_store.add_cert(
      OpenSSL::X509::Certificate.new(Base64.decode64(@config['ca_cert_base64']))
    )

    {
      cert_store: cert_store,
      verify_ssl: OpenSSL::SSL::VERIFY_PEER
    }
  end
end
