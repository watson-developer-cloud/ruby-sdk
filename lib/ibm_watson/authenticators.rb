# frozen_string_literal: true

require("ibm_cloud_sdk_core")

# Module for the Watson APIs
module IBMWatson
  class Authenticators
    BasicAuthenticator = IBMCloudSdkCore::BasicAuthenticator
    BearerTokenAuthenticator = IBMCloudSdkCore::BearerTokenAuthenticator
    CloudPakForDataAuthenticator = IBMCloudSdkCore::CloudPakForDataAuthenticator
    ConfigBasedAuthenticatorFactory = IBMCloudSdkCore::ConfigBasedAuthenticatorFactory
    IamAuthenticator = IBMCloudSdkCore::IamAuthenticator
    NoAuthAuthenticator = IBMCloudSdkCore::NoAuthAuthenticator
  end
end
