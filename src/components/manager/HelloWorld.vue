<template>
  <div>
    <div><H4 style="color:purple;">課程明細</H4></div>    
    <div style="padding: 20px;">
      <h1>歡迎畫面{{testData}}</h1>
      <button v-on:click="test" class="btn btn-primary btn-lg" id="send" style="height:35px; font-size:18px">查詢</button>
      <button v-on:click="test2" class="btn btn-primary btn-lg" id="send" style="height:35px; font-size:18px">查詢2</button>
    <div>
    <div id="container" class="modal-dialog">
        <b-modal id="bv-modal" hide-footer hide-header-close no-close-on-esc no-close-on-backdrop>
            <template #modal-title>
                編輯課程
            </template> 
        </b-modal>   
    <div>
    <div>
        <b-button id="show-btn" @click="$bvModal.show('bv-modal-example')">Open Modal</b-button>

        <b-modal id="bv-modal-example" hide-footer>
            <template #modal-title>
                Using <code>$bvModal</code> Methods
            </template>
            <div class="d-block text-center">
                <h3>Hello From This Modal!</h3>
            </div>
            <b-button class="mt-3" block @click="$bvModal.hide('bv-modal-example')">Close Me</b-button>
        </b-modal>
</div>
  <div>
</template>

<script>
import axios from 'axios';
import Vue from 'vue';
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  mounted() {   
        this.edit();           
  },
  data: function () {
        return {
          testData:'DD',
        }
  },
  methods:{
    edit() 
    {
        this.testData = 'EE';
    },
    test(){
        //this.testData = 'FF';
        const baseURL = '/notifyapi/sendtest'
        axios.get(baseURL)
        .then((response)=>{
            if(response.status===200)
            {
                this.testData = response.data;
            }
            else{
              this.testData = response.status;
            }
        })
    },
    test2(){
        this.testData = 'test2';
        this.$bvModal.show('bv-modal');  
    },
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
