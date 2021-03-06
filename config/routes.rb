# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
Rails.application.routes.draw do
  resources :lists

  root :to => 'contacts#index'

  match 'activities' => 'home#index',              :as => :dashboard
  match 'admin'      => 'admin/users#index',       :as => :admin
  match 'login'      => 'authentications#new',     :as => :login
  match 'logout'     => 'authentications#destroy', :as => :logout
  match 'profile'    => 'users#show',              :as => :profile
  match 'signup'     => 'users#new',               :as => :signup

  match '/home/options',  :as => :options
  match '/home/toggle',   :as => :toggle
  match '/home/timeline', :as => :timeline
  match '/home/timezone', :as => :timezone
  match '/home/redraw',   :as => :redraw

  resource  :authentication, :except => [:index, :edit]
  resources :comments,       :except => [:new, :show]
  resources :emails,         :only   => [:destroy]
  resources :passwords,      :only   => [:new, :create, :edit, :update]

  resources :accounts, :id => /\d+/ do
    collection do
      get  :advanced_search
      post :filter
      get  :options
      get  :field_group
      match :auto_complete
      get  :redraw
      get  :versions
      get :find_duplicates
      match :merge
    end
    member do
      put  :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get  :contacts
    end
  end

  resources :contacts, :id => /\d+/ do
    collection do
      get  :advanced_search
      post :filter
      get  :options
      get  :field_group
      match :auto_complete
      get  :redraw
      get  :versions
      match :import
      get :download_failed_import
      get :find_duplicates
      match :merge
    end
    member do
      put  :attach
      post :discard
      post :subscribe
      post :unsubscribe
    end
  end

  resources :users, :id => /\d+/, :except => [:index, :destroy] do
    member do
      get  :avatar
      get  :password
      put  :upload_avatar
      put  :change_password
      get  :redraw
    end
    collection do
      match :auto_complete
    end
  end

  resources :tags do
    member do
      post :merge
    end
  end

  namespace :admin do
    resources :groups

    resources :users do
      collection do
        match :auto_complete
      end
      member do
        get :confirm
        put :suspend
        put :reactivate
      end
    end

    resources :field_groups, :except => [:index, :show] do
      collection do
        post :sort
      end
      member do
        get :confirm
      end
    end

    resources :fields do
      collection do
        match :auto_complete
        get   :options
        get   :redraw
        post  :sort
        get   :subform
      end
    end

    resources :tags, :except => [:show] do
      member do
        get :confirm
      end
    end

    resources :fields, :as => :custom_fields
    resources :fields, :as => :core_fields

    resources :settings, :only => :index
    resources :plugins,  :only => :index
  end

end
