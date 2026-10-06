
import {test} from 'node:test';import assert from 'node:assert/strict';import {classify,stockReply,validSignature} from '../src/core.mjs';
test('greeting and contact',()=>{assert.equal(classify('Hi').kind,'greeting');assert.equal(classify('owner phone number').kind,'contact')});
test('order requires explicit quantity/time',()=>{assert.deepEqual(classify('/order rice | 2 | today 6pm'),{kind:'order',sku:'rice',qty:2,pickup:'today 6pm'});assert.equal(classify('take an order').kind,'help')});
test('zero stock not available',()=>assert.match(stockReply({name:'Milk',sku:'milk',qty:0,updated_at:'today'}),/out of stock/));
test('unknown contact/stock not fabricated',()=>assert.match(stockReply(null),/exact item code/));
test('HMAC signature rejects spoofed webhook',async()=>{const body='{"test":1}',secret='test-only-not-a-real-secret';const key=await crypto.subtle.importKey('raw',new TextEncoder().encode(secret),{name:'HMAC',hash:'SHA-256'},false,['sign']);const bytes=new Uint8Array(await crypto.subtle.sign('HMAC',key,new TextEncoder().encode(body)));const sig='sha256='+[...bytes].map(x=>x.toString(16).padStart(2,'0')).join('');assert.equal(await validSignature(body,sig,secret),true);assert.equal(await validSignature(body+'x',sig,secret),false);assert.equal(await validSignature(body,'',secret),false)});
