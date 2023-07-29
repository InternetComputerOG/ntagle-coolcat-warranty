<script>
  import { onMount } from "svelte";
  import { auth, tag, scanCredentials } from "../store/auth";

  onMount(async () => {

  });

</script>

<div class="tag-container">
  <h1>Tag Info</h1>
  <h2 class="tag-uid">#{$scanCredentials.uid}</h2>
</div>

<style>
  .container {
    margin: 30px 0;
    padding: 15px;
    border: 1px solid white;
    text-align: left;
    border-radius: 10px;
  }

  h1 {
    margin-bottom: 0px;
  }

  

  h2 {
    margin-top: 80px;
  }

  .tag-uid {
    margin-top: 0px;
  }

  .tag-container {
    margin: 30px 0;
    padding: 15px;
    border: 4px solid white;
    text-align: left;
    border-radius: 20px;
  }

  button {
    margin-left: 0px;
  }

  .img-container {
    padding: 20px;
    background-color: white;
    border-radius: 15px;
    display: inline-block;
  }

  img {
    object-fit: contain;
    height: 60px;
    display: inline-block;
    margin: 0px;
  }

  h6 {
    margin-top: 0px;
  }

  @media (min-width: 640px) {
    .container {
      max-width: 800px;
      margin: 0 auto;
    }
  }
</style>