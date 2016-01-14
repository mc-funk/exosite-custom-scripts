-- Typical HTTP based APIs require authorization.  This example assumes using
  -- Basic Authorization, https://en.wikipedia.org/wiki/Basic_access_authentication
  --
  -- API ENDPOINT
  local api_endpoint = "https://michellefunk.exosite.com/api/portals/v1/portals/2156946736/dashboards"
  -- AUTH VARIABLES
  -- Need to base64 encode the string username:password -- can use https://www.base64encode.org/
  local encoded_auth_string = '<REPLACE WITH YOUR AUTH STRING>'
  --base64_enc(user_email..":"..password)

  local url = string.format(api_endpoint)
  local content_type = "application/json; charset=utf-8"
  local headers = {
    ['Authorization']='Basic '..encoded_auth_string..''
  }
  local body = nil

  local status,resp=dispatch.http(url, "get", body, content_type,headers)

  if status then
    if resp ~= nil and ("200" == tostring(resp['status'])) then
      --local client_cik = resp['body']
      debug(string.format('success '))
      debug(tostring(resp['body']))
      local json_object = json.decode(resp['body'])
      if json_object.count then
        debug('count:'.. tostring(json_object.count))
        count.value = json_object.count
      else
        debug('no count found')
      end
      return true
    else
      if resp ~= nil then debug(string.format('failed! Response Code: %s', resp['status']))
      else   debug(string.format('failed!'))
      end
      return nil
    end
  else
    debug("Failed to access API.  Response: " .. resp)
    if resp == 'limit' then debug('HTTP Dispatch Resouce Limit met') end
    return nil
  end
