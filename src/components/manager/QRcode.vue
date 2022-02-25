<template>
  <form  @submit.prevent="onSubmitShowUrl">
  <div class="form-group">
  <div>
    <vue-qr :correctLevel="3" :autoColor="false" colorDark="#000000" :text="codeUrl" :size="500" :margin="0" :logoMargin="3"></vue-qr>
  </div>
  </div>
  </form>
</template>
<script>
import VueQr from 'vue-qr'
export default {
    data () {
        return {
            codeUrl: this.$route.query.codeUrl,
        }
    },
    mounted() {   
        this.codeUrl= this.$route.query.codeUrl;
    }, 
    components: {
        VueQr
    }
}
</script>