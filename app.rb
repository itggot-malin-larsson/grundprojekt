require 'sinatra'
require 'slim'

enable :sessions

before do
  path = request.path_info
  whitelist = ['/', '/login', '/error', '/documentation', '/profile/show']
  redirect = true

  whitelist.each do |e|
      if path == e
          redirect = false
      end
  end

  if session['user'].nil? and redirect
      redirect('/error')
  end

end

#Startsida
get('/') do
  slim(:index)
end

user_data = [{name: 'Malin', password: 'bananpaj'}, {name: 'Martin', password: 'pananbaj'}]

# Login sida
get('/login') do
  slim(:login)
end

# Kollar om användarnamn och lösenord är korrekt, annars omdirigerar till error sida
post('/login') do
  user_data.each do |user|
    if params['username'] == user[:name] && params['password'] == user[:password]
      session['user'] = params['username']
      redirect('/') 
    end
  end
  redirect('/error')
end

# Error sida
get('/error') do
  slim(:error)
end

#Visa formulär som lägger till en note
get('/notes/new') do
  slim(:"notes/new")
end

# Profil sida
get('/profile/show') do
  if session['user'] != nil
    slim(:"profile/show")
  else
    redirect('/error')
  end
end

# Ändrar användarnamn
post('/profile/edit') do
  session['user']= params['new_username']
  redirect('/')
end

#Skapa note
post('/notes/create') do
  if session["notes"] == nil
    session["notes"] = []
    session["notes"] << [params["ny_note"], params['Rubrik'], params['user']]
  else
    session["notes"] << [params["ny_note"], params['Rubrik'], params['user']]
  end
  redirect('/notes')
end

# Tar bort alla notes
post('/notes/delete') do
  session["notes"] = []
  redirect('/notes')
end

#Visa alla notes
get('/notes') do
  slim(:"notes/show")
end

# Dokumentationssida
get('/documentation') do
  slim(:"/documentation/show")
end