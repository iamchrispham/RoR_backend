Geocoder.configure(

    google: {api_key: ENV['GOOGLE_GEOCODER_API_KEY'], use_https: true},
    lookup: :google,

    ip_lookup: :ipapi_com,

    timeout: 15,
    units: :km,

)
