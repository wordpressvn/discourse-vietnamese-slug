# name: discourse-vietnamese-slug
# about: A Discourse plugin to generate Vietnamese slug
# version: 0.2
# authors: Khoa Nguyen, @eviltrout, @riking
# url: https://github.com/thangngoc89/discourse-vietnamese-slug

after_initialize do
  module ::Slug
    
    def self.for(string, default = 'topic', max_length = MAX_LENGTH, method: nil)

      # For Vietnamese slug
      vietnamese   = "àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐêùà"
      replacements = "aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyydAAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYDeua"
      string = string.tr(vietnamese, replacements)
      # End Vietnamese slug
      method = (method || SiteSetting.slug_generation_method || :ascii).to_sym
      max_length = 9999 if method == :encoded # do not truncate encoded slugs

      slug =
        case method
        when :ascii then self.ascii_generator(string)
        when :encoded then self.encoded_generator(string)
        when :none then self.none_generator(string)
        end

      slug = self.prettify_slug(slug, max_length: max_length)
      (slug.blank? || slug_is_only_numbers?(slug)) ? default : slug
    end

  end
  
  module ::UserNameSuggester
    
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
