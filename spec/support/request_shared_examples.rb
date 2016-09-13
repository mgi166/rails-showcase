shared_examples 'HTTP 200 OK' do
  it do
    subject
    expect(response).to have_http_status 200
  end
end

shared_examples 'HTTP 404 Not Found' do
  it do
    subject
    expect(response).to have_http_status 404
  end
end
