path= File.expand_path('../', __FILE__)
require File.join(path, 'http_client.rb')
require 'json'

=begin
Entrance for Device api.
=end
module JPush
  class DeviceClient
    @@DEVICE_HOST_NAME = 'https://device.jpush.cn'
    @@DEVICE_PATH = '/v3/devices/'
    @@TAG_PATH_LIST = '/v3/tags/'
    
    def initialize(maxRetryTimes)
      @httpclient = JPush::NativeHttpClient.new(maxRetryTimes)
    end

    def getDeviceTagAlias(registration_id)
      result = JPush::TagAliasResult.new
      url = @@DEVICE_HOST_NAME + @@DEVICE_PATH + registration_id
      puts url
      wrapper = @httpclient.sendGet(url, nil)
      result.fromResponse(wrapper)
      return result
    end

    def updateDeviceTagAlias(registration_id, tagAlias)
      json_data = JSON.generate(tagAlias.toJSON)
      url = @@DEVICE_HOST_NAME + @@DEVICE_PATH + registration_id 
      return @httpclient.sendPost(url, json_data)
    end

    def getAppkeyTagList()
      url = @@DEVICE_HOST_NAME + @@TAG_PATH_LIST
      tag_list = JPush::TagListResult.new
      wrapper =  @httpclient.sendGet(url, nil)
      tag_list.fromResponse(wrapper)
      return tag_list
    end

    def userExistsInTag(tag_value, registration_id)
      result = JPush::ExistResult.new
      url = @@DEVICE_HOST_NAME + '/v3/tags/' + tag_value + '/registration_ids/' + registration_id 
      wrapper = @httpclient.sendGet(url, nil)
      result.fromResponse(wrapper)
      return result
    end
    
    def  tagAddingOrRemovingUsers(tag_value, tagManager)
      json_data = JSON.generate(tagManager.toJSON)
      url = @@DEVICE_HOST_NAME + '/v3/tags/' + tag_value
      return @httpclient.sendPost(url, json_data)
    end
    
    def tagDelete(tag_value, platform)

      url = @@DEVICE_HOST_NAME + '/v3/tags/' + tag_value 
      if platform != nil
        url = url + '?platform=' + platform 
      end
      return @httpclient.sendDelete(url, nil)
    end
    
    def getAliasUids(alias_value, platform)
      aliasUidsResult = JPush::AliasUidsResult.new
      url = @@DEVICE_HOST_NAME + '/v3/aliases/' + alias_value  
      if platform != nil
        url = url + '?platform=' + platform
      end
      wrapper = @httpclient.sendGet(url, nil)
      aliasUidsResult.fromResponse(wrapper)
      return aliasUidsResult
    end
    
    def aliasDelete(alias_value, platform)
      url = @@DEVICE_HOST_NAME + '/v3/aliases/' + alias_value  
      if platform != nil
        url = url + '?platform=' + platform 
      end
      return @httpclient.sendDelete(url, nil)
    end
    
  end
end