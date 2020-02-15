title 'Check settings of s3 bucket'

bucket = "devopsdaysmadbucket"

control 'aws_check_s3_basic_settings' do
impact 1.0
title 'Check basic s3 settings like exists and running'
    describe aws_s3_bucket(bucket_name: bucket) do
        it { should exist }
        it { should_not be_public }
    end
end

control 'aws_check_s3_access_control' do
    impact 1.0
    title 'Check access control to s3 bucket'
    describe aws_s3_bucket(bucket_name: bucket) do
        its('bucket_acl.count') { should eq 1 }
        its('bucket_policy') { should be_empty }
    end
end