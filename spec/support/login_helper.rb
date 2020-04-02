module LoginHelper

    def user_signup
      fill_in("user[name]", :with => "Ziggy")
      fill_in("user[email]", :with => "zig@zig.com")
      fill_in("user[password]", :with => "zig")
      click_button('Create Account')
    end
  
    def user_login
      fill_in("user[email]", :with => "zig@zig.com")
      fill_in("user[password]", :with => "zig")
      click_button('Sign In')
    end
  
    def admin_signup
      fill_in("user[name]", :with => "Boss")
      fill_in("user[password]", :with => "boss")
      #find(:css, "#user_admin").set(true)
      click_button('Create Account')
      User.last.admin = true
      User.last.save
    end
  
    def admin_login
        fill_in("user[email]", :with => "zig@zig.com")
        fill_in("user[password]", :with => "zig")
        click_button('Sign In')
    end
  
    def create_standard_user 
      @mindy = User.create(
        name: "Zaggy",
        email: "zag@zag.com"
        password: "zag",
        )
    end
  
    def create_standard_and_admin_user
      @mindy = User.create(
        name: "Mindy",
        password: "password",
        happiness: 3,
        nausea: 2,
        tickets: 10,
        height: 50
      )
      @walt = User.create(
        name: "Walt Disney",
        password: "password",
        admin: true
      )
    end
    
  end