<template>
<div  class="col-12">
<div><H4 style="padding-left: 30px;font-weight:bold;color:rgb(0, 61, 88);">帳號註冊</H4></div>
<form class="form-horizontal form-signin" @submit.prevent="onSubmit">
  <fieldset>
    <div id="legend">
      <legend class="">帳號註冊</legend>
    </div>
    <div class="control-group">
      <!-- Username -->
      <label class="control-label"  for="username">姓名</label>
      <div class="controls">
        <input type="text" id="username" v-model="user.Username" name="username" placeholder="" class="input-xlarge" required>
      </div>
    </div>
 
    <div class="control-group">
      <!-- E-mail -->
      <label class="control-label" for="email">E-mail</label>
      <div class="controls">
        <input type="text" id="email" v-model="user.Email" name="email" placeholder="" class="input-xlarge" required pattern="(?:[a-z0-9!#$%&amp;'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&amp;'*+/=?^_`{|}~-]+)*|&quot;(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*&quot;)@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])">
      </div>
    </div>
 
    <div class="control-group">
      <!-- Password-->
      <label class="control-label" for="password">密碼</label>
      <div class="controls">
        <input type="password" id="password" v-model="user.Password" name="password" placeholder="" class="input-xlarge" required pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*_=+-]).{8,32}$" >
        <u>
          <li style="font-size:12px;color:red">至少一個大寫字母</li>
          <li style="font-size:12px;color:red">至少一個小寫字母</li>
          <li style="font-size:12px;color:red">至少一個數字</li>
          <li style="font-size:12px;color:red">至少一個符號 : !@#$%^&*_=+-</li>
          <li style="font-size:12px;color:red">8-32碼</li>
        </u>
      </div>
    </div>
 
    <div class="control-group">
      <!-- Password -->
      <label class="control-label"  for="password_confirm">密碼確認</label>
      <div class="controls">
        <input type="password" id="password_confirm" name="password_confirm" placeholder="" class="input-xlarge" required>
      </div>
    </div>
 
    <div class="control-group">
      <!-- Button -->
      <div class="controls">
        <button class="btn btn-success">註冊</button>
      </div>
    </div>
  </fieldset>
</form>
<vue-toastr ref="toastr"></vue-toastr>
</div>
</template>
<script>
import Vue from 'vue';
import VueToast from 'vue-toast-notification';
import 'vue-toast-notification/dist/theme-sugar.css';
import axios from 'axios';
Vue.use(VueToast);
export default {
  name: "SignUp",
  data(){
    return{
      user:{
        Username:'',
        Email:'',
        Password:''
      },
    }
  }, 
  mounted: function(){    

  },
  methods: {  
    onSubmit: async function () 
    {
      var password=document.getElementById('password').value;
      var password_confirm=document.getElementById('password_confirm').value;
      if(password!==password_confirm){
        Vue.$toast.open({
        message: '【密碼確認】與【密碼】不同',
        position: 'top',
        type: 'error'
        });  
      }
      else{
          axios.post(this.$httpPath+'/AuthManagement/register', this.user)
              .then((response) => {
                  if(response.status==200)
                  {
                    Vue.$toast.open({
                    message: '帳戶建立成功',
                    position: 'bottom-right',
                    type: 'success'
                    });  
                  }
                  else
                  {
                    Vue.$toast.open({
                    message: response.data.error,
                    position: 'top',
                    type: 'error'
                    });  
                  }
              })
              .catch((error) => {
                    console.log(error);
                    Vue.$toast.open({
                    message: error,
                    position: 'top',
                    type: 'error'
                    }); 
              }).finally(() => {
          }); 
      }        
    }
  },
  components: {
 
  },  
};
</script>
<style>
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