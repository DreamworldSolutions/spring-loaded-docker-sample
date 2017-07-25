package com.dw.springloadeddockersample;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
@Order(1000)
public class SecurityConfig extends WebSecurityConfigurerAdapter {

  @Autowired
  public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
    auth.inMemoryAuthentication().withUser("admin").password("admin").roles("USER");
  }

  @Configuration
  public static class ApiWebSecurityConfigurationAdapter extends WebSecurityConfigurerAdapter {
    protected void configure(HttpSecurity http) throws Exception {
      http.antMatcher("/**").authorizeRequests().anyRequest().hasRole("USER").and().httpBasic();
    }
  }
}
