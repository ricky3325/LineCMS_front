<template>
  <div class="col-2"> <img class="title" alt=""/><br />
  <form class="form-signin" @submit.prevent="login"> 
        <h1 class="h3 mb-3 font-weight-normal">請登入</h1>
        <!-- <label for="inputEmail" class="sr-only">帳號</label> -->
        <input type="email" id="inputEmail" class="form-control" v-model="user.email" placeholder="Email address" required autofocus>
        <!-- <label for="inputPassword" class="sr-only">密碼</label> -->
        <input type="password" id="inputPassword" class="form-control"  v-model="user.password" placeholder="Password" required>
        <button class="btn btn-lg btn-primary btn-block" type="submit">登入</button>
  </form>
  </div>
</template>
<script>
import axios from "axios";
export default {
  name: "Login",
  data: function () {
    return {
      user:{
        email:'',
        password:''
      }
    }
  },
  components: {

  },
  methods: {
    login()
    {
      this.$store.dispatch('logIn', this.user);
    }
  },
};
</script>
<style scoped>
html,
/* body {
  height: 100%;
}

body {
  display: -ms-flexbox;
  display: flex;
  -ms-flex-align: center;
  align-items: center;
  padding-top: 40px;
  padding-bottom: 40px;
  background-color: #f5f5f5;
} */

.form-signin {
  width: 100%;
  max-width: 330px;
  padding: 15px;
  margin: auto;
}
.form-signin .checkbox {
  font-weight: 400;
}
.form-signin .form-control {
  position: relative;
  box-sizing: border-box;
  height: auto;
  padding: 10px;
  font-size: 16px;
}
.form-signin .form-control:focus {
  z-index: 2;
}
.form-signin input[type="email"] {
  margin-bottom: -1px;
  border-bottom-right-radius: 0;
  border-bottom-left-radius: 0;
}
.form-signin input[type="password"] {
  margin-bottom: 10px;
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}
</style>
