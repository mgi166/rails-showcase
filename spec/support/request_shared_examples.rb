shared_examples 'HTTP 200 OK' do
  it do
    subject
    expect(response).to have_http_status 200
  end
end
