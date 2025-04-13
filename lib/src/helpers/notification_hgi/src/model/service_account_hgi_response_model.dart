class ServiceAccountHgiResponseModel {
  ServiceAccountHgiResponseModel({
    String? type,
    String? projectId,
    String? privateKeyId,
    String? privateKey,
    String? clientEmail,
    String? clientId,
    String? authUri,
    String? tokenUri,
    String? authProviderX509CertUrl,
    String? clientX509CertUrl,
    String? universeDomain,
  }) {
    _type = type;
    _projectId = projectId;
    _privateKeyId = privateKeyId;
    _privateKey = privateKey;
    _clientEmail = clientEmail;
    _clientId = clientId;
    _authUri = authUri;
    _tokenUri = tokenUri;
    _authProviderX509CertUrl = authProviderX509CertUrl;
    _clientX509CertUrl = clientX509CertUrl;
    _universeDomain = universeDomain;
  }

  String? _type;

  String? get type => _type;

  String? _projectId;

  String? get projectId => _projectId;

  String? _privateKeyId;

  String? get privateKeyId => _privateKeyId;

  String? _privateKey;

  String? get privateKey => _privateKey;

  String? _clientEmail;

  String? get clientEmail => _clientEmail;

  String? _clientId;

  String? get clientId => _clientId;

  String? _authUri;

  String? get authUri => _authUri;

  String? _tokenUri;

  String? get tokenUri => _tokenUri;

  String? _authProviderX509CertUrl;

  String? get authProviderX509CertUrl => _authProviderX509CertUrl;

  String? _clientX509CertUrl;

  String? get clientX509CertUrl => _clientX509CertUrl;

  String? _universeDomain;

  String? get universeDomain => _universeDomain;

  ServiceAccountHgiResponseModel.fromJson(dynamic json) {
    _type = json["type"];
    _projectId = json["project_id"];
    _privateKeyId = json["private_key_id"];
    _privateKey = json["private_key"];
    _clientEmail = json["client_email"];
    _clientId = json["client_id"];
    _authUri = json["auth_uri"];
    _tokenUri = json["token_uri"];
    _authProviderX509CertUrl = json["auth_provider_x509_cert_url"];
    _clientX509CertUrl = json["client_x509_cert_url"];
    _universeDomain = json["universe_domain"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["type"] = _type;
    map["project_id"] = _projectId;
    map["private_key_id"] = _privateKeyId;
    map["private_key"] = _privateKey;
    map["client_email"] = _clientEmail;
    map["client_id"] = _clientId;
    map["auth_uri"] = _authUri;
    map["token_uri"] = _tokenUri;
    map["auth_provider_x509_cert_url"] = _authProviderX509CertUrl;
    map["client_x509_cert_url"] = _clientX509CertUrl;
    map["universe_domain"] = _universeDomain;
    return map;
  }
}
