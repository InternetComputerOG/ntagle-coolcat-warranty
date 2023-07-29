<script>
  import { AuthClient } from "@dfinity/auth-client";
  import { onMount } from "svelte";
  import { adminStatus, auth, createActor, scanCredentials, tag } from "../store/auth";

  /** @type {AuthClient} */
  let client;
  let url = window.location.href;

  if (url.length < 88) {
    console.log("Something's wrong, URL too short.");
  };

  let uid = url.slice(50,64);
  let ctr = parseInt(url.slice(65,71), 16);
  let cmac = url.slice(72,88);
  let loading = false;
  console.log("url: " + url);
  console.log("uid: " + uid);
  console.log("ctr: " + ctr);
  console.log("cmac: " + cmac);

  let message = "Please wait while we load your coolcat experience!";

  scanCredentials.update(() => ({
    uid: uid,
    ctr: ctr,
    cmac: cmac
  }));

  onMount(async () => {
    validateScan();
  });

  async function validateScan() {
    loading = true;
    console.log("Starting to validate scan...");
    let scan_param = {
      uid: uid,
      ctr: ctr,
      cmac: cmac
    };

    let result = await $auth.actor.scan(scan_param);
    console.log(result);
    if ( result.hasOwnProperty("Ok") ) {
      tag.update(() => ({
        valid: true,
        scans_left: result.Ok.scans_left,
        years_left: result.Ok.years_left
      }));
      message = "Scan validated!";
      setTimeout(() => {
        message = "";
      }, 50000)
    } else if ( result.hasOwnProperty("Err") ) {
      message = "Scan not valid. Please try scanning your card again." // result.Err.msg;
    } else {
      message = "Something went wrong, your scan could not be validated."
    };
    loading = false;
  };
</script>

<div class="container">
  <h3>{#if loading}<div class="loader"></div>{/if}{" " + message}</h3>
</div>

<style>
  .container {
    /* margin: 30px 0 30px; */
    padding: 15px;
  }
</style>
