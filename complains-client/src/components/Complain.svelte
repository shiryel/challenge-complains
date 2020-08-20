<script>
  import { onMount } from "svelte";
  export let complain = {};
</script>

<style>
  .complain {
    min-width: 200px;
    background-color: #d5dbe3;
    margin: 10px;
    padding: 10px;
    border-radius: 10px;
    max-width: 400px;
  }

  div {
    background-color: #BBC4D0;
    padding: 5px;
    margin-top: 10px;
    border-radius: 10px;
  }

  label {
    border-bottom: black solid 1px;
  }
</style>

<div class="complain">
  <h3>{complain.title}</h3>
  <p id="description">{complain.description}</p>

  <div id="company">
  <label for="company">Company:</label>
    <h4>{complain.company.name}</h4>
    {#if complain.company.description}
    <p>{complain.company.description}</p>
    {/if}
  </div>

  <div id="locale">
  <label for="locale">Location:</label>
    {#if complain.locale.state && complain.locale.city}
    <p>{complain.locale.country} - {complain.locale.state}, {complain.locale.city}</p>
    {/if}
    {#if complain.locale.state && !complain.locale.city}
    <p>{complain.locale.country} - {complain.locale.state}</p>
    {/if}
    {#if !complain.locale.state && !complain.locale.city}
    <p>{complain.locale.country}</p>
    {/if}
  </div>
</div>
