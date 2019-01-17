EmailAddress::Config.configure(
  local_format: :relaxed,
  local_downcase: true,
  local_fix: true
)

EmailAddress::Config.error_messages(
  invalid_address:    'is invalid',
  invalid_mailbox:    'Invalid Recipient/Mailbox',
  invalid_host:       'Invalid Host/Domain Name',
  exceeds_size:       'Address too long',
  not_allowed:        'Address is not allowed',
  incomplete_domain:  'Domain name is incomplete'
)
