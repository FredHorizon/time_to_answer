module UsersBackofficeHelper
	
	# Para o avatar aparecer no perfil
	def avatar_url
		avatar = current_user.user_profile.avatar
		avatar.attached? ? avatar : 'img.jpg' # avatar possui imagem anexada? se sim(?), avatar. Senão(:) usar img.jpg
	end

end
