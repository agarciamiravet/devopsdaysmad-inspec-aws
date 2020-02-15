title 'Check settings of ec2'

#Read data from terraform output
terraformContent = inspec.profile.file('terraform.json')
terraformsParams = JSON.parse(terraformContent)

# ec2 id
ec2_id = terraformsParams['ec2_id']['value']

control 'aws-check-ec2-basic-settings' do
    describe aws_ec2_instance(ec2_id) do
        it { should be_running }
        it { should have_roles }
      end
end