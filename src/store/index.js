import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";
import router from '@/router'

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    refresh_token: "",
    access_token: "",
    loggedInUser: {},
    isAuthenticated: false,
    selectedCatImg:"",
  },
  mutations: {
    setRefreshToken: function(state, refreshToken) {
      state.refresh_token = refreshToken;
    },
    setAccessToken: function(state, accessToken) {
      state.access_token = accessToken;
      localStorage.setItem("isAuthenticated",true);
    },
    // sets state with user information and toggles 
    // isAuthenticated from false to true
    setLoggedInUser: function(state, user) {
      state.loggedInUser = user;
      state.isAuthenticated = true;
    },
    // delete all auth and user information from the state
    clearUserData: function(state) {
      state.refresh_token = "";
      state.access_token = "";
      state.loggedInUser = {};
      state.isAuthenticated = false;
      localStorage.setItem("access_token","");
    },  
  },
  actions: {
    logIn: async ({ commit, dispatch }, {email,password}) => {
      let self = this
      const loginUrl = Vue.prototype.$httpPath+'/AuthManagement/login';
      try {
        await axios.post(loginUrl, {email,password}).then(response => {
          if (response.status === 200) {
            localStorage.setItem("access_token",response.data.token);
            commit("setRefreshToken", response.data.refreshToken);
            commit("setAccessToken", response.data.token);
            router.push("/manager");
          }
        });
      } catch (e) {
        console.log(e);
      }
    },
    refreshToken: async ({ state, commit }) => {
      const refreshUrl = Vue.prototype.$httpPath+'/AuthManagement/RefreshToken';
      try {
        await axios
          .post(refreshUrl, { Token: state.access_token, RefreshToken: state.refresh_token })
          .then(response => {
            if (response.status === 200) {
              commit("setRefreshToken", response.data.refreshToken);
              commit("setAccessToken", response.data.token);
            }
          });
      } catch (e) {
        console.log(e.response);
      }
    },
    fetchUser: async ({ commit }) => {
      const currentUserUrl = "v1/auth/users/me/";
      try {
        await axios.get(currentUserUrl).then(response => {
          if (response.status === 200) {
            commit("setLoggedInUser", response.data);
          }
        });
      } catch (e) {
        console.log(e.response);
      }
    },   
    logout: async ({ commit, dispatch }) => {
      commit("clearUserData");
      router.push("/login");
    },    
  },
  getters: {
    loggedInUser: state => state.loggedInUser,
    isAuthenticated: state => state.isAuthenticated,
    accessToken: state => state.access_token,
    refreshToken: state => state.refresh_token, 
  }
});
