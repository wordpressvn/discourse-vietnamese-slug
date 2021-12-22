# name: discourse-vietnamese-slug
# about: A Discourse plugin to generate Vietnamese slug
# version: 0.2
# authors: Khoa Nguyen, @eviltrout, @riking
# url: https://github.com/wordpressvn/discourse-vietnamese-slug

after_initialize do
  module Slug

    def self.for(string, default = 'topic')

      # For Vietnamese slug
      vietnamese   = "àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐêùà"
      replacements = "aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyydAAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYDeua"
      string = string.tr(vietnamese, replacements)
      # End Vietnamese slug
      slug = case (SiteSetting.slug_generation_method || :ascii).to_sym
           when :ascii then self.ascii_generator(string)
           when :encoded then self.encoded_generator(string)
           when :none then self.none_generator(string)
           end
      # Reject slugs that only contain numbers, because they would be indistinguishable from id's.
      slug = (slug =~ /[^\d]/ ? slug : '')
      slug.blank? ? default : slug
    end

  end
  
  module UserNameSuggester
    
    def self.sanitize_username(name)
      
      # For Vietnamese slug
      vietnamese   = "àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐêùà"
      replacements = "aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyydAAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYDeua"
      name = name.tr(vietnamese, replacements)
      # End Vietnamese slug
      
      name = ActiveSupport::Inflector.transliterate(name)
      name = name.gsub(/^[^[:alnum:]]+|\W+$/, "")
                 .gsub(/\W+/, "_")
                 .gsub(/^\_+/, '')
                 .gsub(/[\-_\.]{2,}/, "_")
      name
    end
  
  end

end
