class AwsS3Service
  @aws_s3 = Aws::S3::Resource.new(region: ENV.fetch('AWS_REGION'))

  def self.get_presigned_url(file_name, args = {})
    folder_name = args[:folder_name].presence || 'files'
    full_path = folder_name + '/' + SecureRandom.urlsafe_base64(8) + '_' + file_name
    @aws_s3.bucket(ENV.fetch('AWS_BUCKET')).object(full_path).presigned_url(:put)
  end
end
