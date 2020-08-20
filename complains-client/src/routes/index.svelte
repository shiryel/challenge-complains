<script>
  import Complain from "../components/Complain.svelte";
  import ComplainForm from "../components/ComplainForm.svelte";
  import { onMount } from "svelte";

  let complains = [];
  let page = 1;
  let size = 50;
  let company_name = "";
  let country = "";
  let state = "";
  let city = "";

  onMount(async () => {
    getComplains();
  });

  function getComplains() {
    let params = `page=${page}&size=${size}`;
    if (company_name) {
      params += `&company_name=${company_name}`;
    }
    if (country) {
      params += `&locale_country=${country}`;
    }
    if (state) {
      params += `&locale_state=${state}`;
    }
    if (city) {
      params += `&locale_city=${city}`;
    }
    fetch(`http://localhost:4000/api/complains?${params}`)
      .then((res) => {
        if (res.status == 200) {
          return res.json();
        } else {
          throw new Error("Server error");
        }
      })
      .then((res) => {
        complains = res;
      });
  }
</script>

<style>
  .complains {
    display: flex;
    flex-wrap: wrap;
    max-width: 1200px;
    justify-content: center;
    border-radius: 10px;
  }

  .bar {
    display: flex;
    flex-wrap: wrap;
    margin-top: 50px;
    justify-content: center;
    align-items: center;
  }

  input {
    width: 50px;
    margin: 7px;
  }

  #company_name {
    width: 150px;
  }

  #country {
    width: 100px;
  }

  #city {
    width: 150px;
  }

  @media (min-width: 480px) {
  }
</style>

<svelte:head>
  <title>Sapper project template</title>
</svelte:head>

<ComplainForm />

<div class="bar">
  <label for="country">Country:</label>
  <input id="country" type="text" bind:value={country} />
  <label for="state">State:</label>
  <input id="state" type="text" bind:value={state} />
  <label for="city">City:</label>
  <input id="city" type="text" bind:value={city} />
  <label for="company_name">Company name:</label>
  <input id="company_name" type="text" bind:value={company_name} />
</div>
<div class="bar">
  <label for="page">Page:</label>
  <input id="page" type="number" bind:value={page} />
  <label for="size">Size:</label>
  <input id="size" type="number" bind:value={size} />
  <button on:click={getComplains}>Reflesh</button>
</div>
<div class="complains">
  {#each complains as complain}
    <Complain {complain} />
  {/each}
</div>
<div class="bar">
  <label for="page">Page:</label>
  <input id="page" type="number" bind:value={page} />
  <label for="size">Size:</label>
  <input id="size" type="number" bind:value={size} />
  <button on:click={getComplains}>Reflesh</button>
</div>
